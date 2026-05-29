{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00227') }},
        {{ ref('model_00002') }},
        {{ ref('model_00349') }}
)
select id, 'model_00914' as name from sources
