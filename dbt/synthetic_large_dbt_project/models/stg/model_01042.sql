{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00529') }},
        {{ ref('model_00546') }},
        {{ ref('model_00737') }}
)
select id, 'model_01042' as name from sources
