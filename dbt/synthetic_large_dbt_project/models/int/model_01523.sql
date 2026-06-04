{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00979') }},
        {{ ref('model_01248') }},
        {{ ref('model_01014') }}
)
select id, 'model_01523' as name from sources
