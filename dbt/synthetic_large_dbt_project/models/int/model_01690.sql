{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00956') }},
        {{ ref('model_01005') }}
)
select id, 'model_01690' as name from sources
