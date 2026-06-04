{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01007') }},
        {{ ref('model_01233') }},
        {{ ref('model_01223') }}
)
select id, 'model_02218' as name from sources
