{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02008') }},
        {{ ref('model_01835') }},
        {{ ref('model_01898') }}
)
select id, 'model_02965' as name from sources
