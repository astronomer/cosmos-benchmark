{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01050') }},
        {{ ref('model_01424') }},
        {{ ref('model_01296') }}
)
select id, 'model_01790' as name from sources
