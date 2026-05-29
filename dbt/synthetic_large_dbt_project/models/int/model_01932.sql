{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01193') }},
        {{ ref('model_00954') }}
)
select id, 'model_01932' as name from sources
