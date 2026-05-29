{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00708') }},
        {{ ref('model_00716') }},
        {{ ref('model_00609') }}
)
select id, 'model_01175' as name from sources
