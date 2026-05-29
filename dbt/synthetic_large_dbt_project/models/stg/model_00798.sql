{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00514') }},
        {{ ref('model_00329') }},
        {{ ref('model_00397') }}
)
select id, 'model_00798' as name from sources
