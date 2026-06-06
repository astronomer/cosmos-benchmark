{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01492') }},
        {{ ref('model_00895') }}
)
select id, 'model_02115' as name from sources
