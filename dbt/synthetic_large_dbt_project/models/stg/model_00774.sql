{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00248') }},
        {{ ref('model_00475') }},
        {{ ref('model_00377') }}
)
select id, 'model_00774' as name from sources
