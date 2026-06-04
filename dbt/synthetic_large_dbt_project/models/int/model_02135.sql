{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00861') }},
        {{ ref('model_00829') }}
)
select id, 'model_02135' as name from sources
