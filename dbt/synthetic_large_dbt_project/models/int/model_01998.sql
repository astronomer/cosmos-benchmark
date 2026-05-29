{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00790') }},
        {{ ref('model_01095') }},
        {{ ref('model_01410') }}
)
select id, 'model_01998' as name from sources
