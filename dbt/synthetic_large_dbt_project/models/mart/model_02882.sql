{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02178') }},
        {{ ref('model_01748') }},
        {{ ref('model_02001') }}
)
select id, 'model_02882' as name from sources
