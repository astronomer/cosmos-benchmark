{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01939') }},
        {{ ref('model_01581') }},
        {{ ref('model_01836') }}
)
select id, 'model_02838' as name from sources
